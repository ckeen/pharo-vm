as yet unclassified
defineGlobalTargets

	"none"
	vmGen
		set: #installPrefix toString: '${thirdpartyDir}/out';
		set: #pkgconfigPath toString: '${installPrefix}/bin/pkg-config.exe'
		