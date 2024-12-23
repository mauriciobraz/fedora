#!/usr/bin/python3

# Authored by Phạm Văn Phúc.
# https://github.com/ppvan/nautilus-open-in-blackbox

import os
import shutil
import locale
import logging
import subprocess

from gettext import gettext

from gi import require_version
from gi.repository import GObject, Nautilus

require_version("Gtk", "4.0")
require_version("Nautilus", "4.0")

TERMINAL_NAME = "com.raggesilver.BlackBox"

if os.environ.get("NAUTILUS_BLACKBOX_DEBUG", "False") == "True":
    logging.basicConfig(level=logging.DEBUG)


class BlackBoxNautilus(GObject.GObject, Nautilus.MenuProvider):
    def __init__(self):
        super().__init__()
        self.is_select = False
        pass

    def get_file_items(self, files: list[Nautilus.FileInfo]):
        """Return to menu when click on any file/folder"""
        if not self.only_one_file_info(files):
            return []

        menu = []
        fileInfo = files[0]
        self.is_select = False

        if fileInfo.is_directory():
            self.is_select = True
            dir_path = self.get_abs_path(fileInfo)

            logging.debug("Selecting a directory!!")
            logging.debug(f"Create a menu item for entry {dir_path}")

            menu_item = self._create_nautilus_item(dir_path)
            menu.append(menu_item)

        return menu

    def get_background_items(self, directory):
        """Returns the menu items to display when no file/folder is selected
        (i.e. when right-clicking the background)."""

        # Some concurrency problem fix. When you select a directory, and right
        # mouse, nautilus will call this once the moments you focus the menu.
        # This code to ignore that time.

        if self.is_select:
            self.is_select = False
            return []

        menu = []

        if directory.is_directory():
            dir_path = self.get_abs_path(directory)

            logging.debug("Not thing is selected. Launch from backgrounds!")
            logging.debug(f"Create a menu item for entry {dir_path}")

            menu_item = self._create_nautilus_item(dir_path)
            menu.append(menu_item)

        return menu

    def is_native(self):
        if shutil.which("blackbox-terminal") == "/usr/bin/blackbox-terminal":
            return "blackbox-terminal"

        if shutil.which("blackbox") == "/usr/bin/blackbox":
            return "blackbox"

    def get_abs_path(self, fileInfo: Nautilus.FileInfo):
        path = fileInfo.get_location().get_path()
        return path

    def only_one_file_info(self, files: list[Nautilus.FileInfo]):
        return len(files) == 1

    def _nautilus_run(self, _, path: str):
        """'Open with Black Box 's menu item callback."""
        logging.debug(f"Open with Black Box {path=}")
        args = None

        if self.is_native() == "blackbox-terminal":
            args = ["blackbox-terminal", "-w", path]
        elif self.is_native() == "blackbox":
            args = ["blackbox", "-w", path]
        else:
            args = ["/usr/bin/flatpak", "run", TERMINAL_NAME, "-w", path]

        subprocess.Popen(args, cwd=path)

    def _create_nautilus_item(self, dir_path: str) -> Nautilus.MenuItem:
        """Creates the 'Open In Black Box' menu item."""

        match locale.getlocale()[0].split("_")[0]:
            case "pt":
                text_label = "Abrir no Black Box"
            case _:
                text_label = "Open in Black Box"

        match locale.getlocale()[0].split("_")[0]:
            case "pt":
                text_tip = "Abrir esta pasta/arquivo no Black Box"
            case _:
                text_tip = "Open this folder/file in Black Box Terminal"

        item = Nautilus.MenuItem(
            name="BlackBoxNautilus::open_in_blackbox",
            label=gettext(text_label),
            tip=gettext(text_tip),
        )

        item.connect("activate", self._nautilus_run, dir_path)
        logging.debug(f"Connectted trigger to menu item ({dir_path=})")

        return item
