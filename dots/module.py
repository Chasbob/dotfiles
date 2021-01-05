import configparser
import hashlib
import os
import shutil
import subprocess
import urllib.request
from pathlib import Path
from typing import Dict, Iterable, Optional, Tuple

from .utils import confirm


class Module:
    """
    A single selectable package of configuration files.
    """

    def __init__(self, config: Path):
        self.path = config.parent

        self.config = configparser.ConfigParser(
            interpolation=configparser.ExtendedInterpolation(),
        )
        self.config.optionxform = lambda option: option  # type: ignore
        self.config.read(config)

        meta = self._section("meta")
        self.name = meta.get("name", self.path.name)
        self.dependencies = []
        for dep in meta.get("dependencies", "").split():
            if dep:
                self.dependencies.append(dep)

        self.contents = FilePairs.from_config(self._section("contents"))
        self.symlinks = FilePairs.from_config(self._section("symlinks"))
        self.pre_hook = Hook.from_config(self._section("pre-hook"))
        self.post_hook = Hook.from_config(self._section("post-hook"))

    def resolve_dependencies(self, modules: Dict[str, "Module"]) -> Iterable["Module"]:
        """
        Recursively find all module dependencies from the provided collection.
        """

        # TODO: detect circular dependencies

        if self.dependencies:
            for dependency in self.dependencies:
                yield from modules[dependency].resolve_dependencies(modules)
                yield modules[dependency]

    def install(self, dest: Path):
        # ensure target exists
        os.makedirs(dest, exist_ok=True)

        # run pre-hook
        if self.pre_hook:
            self.pre_hook.run(dest)

        # copy configs
        for dst, src in self.contents.targets(dest, self.path):
            shutil.copy(src, dst)

        # create symlinks
        for dst, src in self.symlinks.targets(dest, self.path):
            try:
                os.symlink(src, dst)
            except FileExistsError:
                os.remove(dst)
                os.symlink(src, dst)

        # run post-hook
        if self.post_hook:
            self.post_hook.run(dest)

    def _section(self, key: str) -> Dict[str, str]:
        if key in self.config:
            return dict(self.config[key])
        else:
            return {}

    def __repr__(self) -> str:
        return f"<Module {self.name}>"


class FilePairs:
    """
    A collection of files, made up of pairs of destination and source.
    """

    def __init__(self, files: Iterable[Tuple[str, str]]):
        self.paths = [(Path(key), Path(value)) for key, value in files]

    @staticmethod
    def from_config(config: Dict[str, str]) -> "FilePairs":
        return FilePairs(config.items())

    def targets(self, dest: Path, source: Path) -> Iterable[Tuple[Path, Path]]:
        for dst, src in self.paths:
            dest_file = dest / dst
            src_file = source / src
            os.makedirs(dest_file.parent, exist_ok=True)

            yield dest_file, src_file


class Hook:
    """
    A command to be run after a specified trigger.
    """

    def __init__(
        self,
        cmd: Optional[str] = None,
        url: Optional[str] = None,
        hash: Optional[str] = None,
    ):
        self.cmd = cmd
        self.url = url
        self.hash = hash.split(":") if hash else None

    @staticmethod
    def from_config(config: Dict[str, str]) -> Optional["Hook"]:
        if config:
            return Hook(**config)
        else:
            return None

    def run(self, root: Path):
        """
        Execute the hook at the specified path.
        """

        if self.cmd:
            self._run_cmd(root)
        if self.url:
            self._run_url(root)

    def _run_cmd(self, root: Path):
        assert self.cmd is not None

        self._integrity_check(self.cmd)
        subprocess.run(self.cmd, cwd=root, shell=True, check=True)

    def _run_url(self, root: Path):
        assert self.url is not None

        with urllib.request.urlopen(self.url) as response:
            script = response.read()
        self._integrity_check(script)
        if not self._user_check(script.decode(), self.url):
            return

        # TODO: find better temporary file
        fname = "/tmp/dots.sh"
        with open(fname, "wb") as f:
            f.write(script)
        os.chmod(f.name, 0o755)
        subprocess.run([fname], cwd=root, check=True)
        os.remove(fname)

    def _user_check(self, script: str, name: Optional[str] = None) -> bool:
        print("=" * 80)
        if name:
            print(self.url)
            print("-" * 80)
        print(script.strip())
        print("=" * 80)
        if confirm("Run script?"):
            print(f"Running {self.url}")
            return True
        else:
            print("Hook skipped")
            return False

    def _integrity_check(self, target: str):
        if not self.hash:
            return

        if isinstance(target, bytes):
            data = target
        elif isinstance(target, str):
            data = target.encode()
        else:
            raise RuntimeError()

        m = hashlib.new(self.hash[0], data)
        if m.hexdigest() != self.hash[1]:
            # TODO: we should fail better here
            raise RuntimeError("integrity check failed")


def load_modules(root: Path) -> Dict[str, Module]:
    """
    Load all modules found in the specified path.
    """

    modules = {}
    for config in root.glob("**/config.ini"):
        module = Module(config)
        if module.name in modules:
            raise RuntimeError(f"{module.name} exists in two places!")

        modules[module.name] = module
    return modules
