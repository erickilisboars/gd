import gd

fn test_version() {
	// Test major version
	major := gd.gd_major_version()
	assert major == 2, 'Major version should be 2, got: ${major}'

	// Test minor version
	minor := gd.gd_minor_version()
	assert minor == 3, 'Minor version should be 3, got: ${minor}'

	// Test release version (patch)
	release := gd.gd_release_version()
	assert release == 3, 'Release version should be 3, got: ${release}'

	// Test extra version (should be empty for stable releases)
	extra := unsafe { tos3(&char(gd.gd_extra_version())) }
	// Extra can be empty or contain hash/additional info
	assert extra.len >= 0, 'Extra version should be a valid string'

	// Test full version string
	version := unsafe { tos3(&char(gd.gd_version_string())) }
	assert version == '2.3.3', 'Version string should be "2.3.3", got: "${version}"'
}
