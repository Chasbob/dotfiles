def confirm(prompt: str) -> bool:
    confirmation = input(f"{prompt} [y/N] ")
    if confirmation:
        if confirmation[0].lower() == "y":
            return True

    return False
