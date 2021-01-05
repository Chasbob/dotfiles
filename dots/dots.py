import argparse
import sys
from pathlib import Path

from .module import load_modules
from .utils import confirm


def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers()

    parser_install = subparsers.add_parser("install")
    parser_install.add_argument("-d", "--dest", default=Path.home())
    parser_install.add_argument("targets", nargs="+")
    parser_install.set_defaults(action=action_install)

    parser_list = subparsers.add_parser("list")
    parser_list.set_defaults(action=action_list)

    args = parser.parse_args()
    if hasattr(args, "action"):
        args.action(args)
    else:
        parser.print_usage()


def action_list(args):
    """
    List all available modules.
    """

    module_root = Path("modules/")
    modules = load_modules(module_root)

    print("Available modules:")
    for module in modules:
        print(f"- {module}")


def action_install(args):
    """
    Install specified modules (and their dependencies).
    """

    dest = Path(args.dest)

    module_root = Path("modules/")
    modules = load_modules(module_root)

    try:
        candidates = {modules[target] for target in args.targets}
        dependencies = set()
        for candidate in candidates:
            dependencies |= set(candidate.resolve_dependencies(modules))
        candidates |= dependencies
    except KeyError as e:
        key = e.args[0]
        print(f"{key} module not found")
        sys.exit(1)

    print(f"Will install: {', '.join(c.name for c in candidates)}")
    if not confirm("install?"):
        return

    for mod in candidates:
        print(f"Installing {mod.name}...")
        mod.install(dest)
