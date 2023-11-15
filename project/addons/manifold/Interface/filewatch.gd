class_name ManifoldFileWatch
extends Node

# https://github.com/KoBeWi/Godot-Directory-Watcher/blob/master/DirectoryWatcher.gd

var _directory : DirAccess = DirAccess.open(".")

var _directory_list : Dictionary



#region // 󰘊 SIGNALS.

signal file_created(files)

signal file_modified(files)

signal file_deleted(files)

signal file_renamed(files)

#endregion 󰘊 SIGNALS.
