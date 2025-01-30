let modcpp = HEMTT_VFS.join("mod.cpp").open_file().read();
if HEMTT.project().version().build() > 0 {
	modcpp.replace("0.0.0.0", HEMTT.project().version().to_string());
} else {
	modcpp.replace("0.0.0.0", HEMTT.project().version().to_string_short());
}
HEMTT_VFS.join("mod.cpp").create_file().write(modcpp);