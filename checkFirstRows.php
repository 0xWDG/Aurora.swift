<?php
// PLEASE NOTE
// this works, but need some improvements, which will be made, or not.
// this was created in a hurry.
// if you have a better idea.
// or improvemens, please feel welcome to contribute.

$expectedHeader = <<<HEADER
// Aurora framework for Swift
//
// The **Aurora.framework** contains a base for your project.
//
// It has a lot of extensions built-in to make development easier.
//
// - Version: 1.0
// - Copyright: [Wesley de Groot](https://wesleydegroot.nl) ([WDGWV](https://wdgwv.com))\
//  and [Contributors](https://github.com/AuroraFramework/Aurora.swift/graphs/contributors).
//
// Please note: this is a beta version.
// It can contain bugs, please report all bugs to https://github.com/AuroraFramework/Aurora.swift
//
// Thanks for using!
//
// Licence: Needs to be decided.
HEADER;

echo $expectedHeader . PHP_EOL;

$expectedHeaderSplit = explode("\n", $expectedHeader);

$aurora = array(
	'main' => glob("Sources/Aurora/*.swift"),
	'classess' => glob("Sources/Aurora/Classes/*.swift"),
	'extensions' => glob("Sources/Aurora/Extensions/*.swift"),
	'tests' => glob("Tests/AuroraTests/*.swift"),
);

foreach ($aurora as $key => $value) {
	checkFilesInArray($value);
}

function checkFilesInArray($files) {
	global $expectedHeaderSplit, $expectedHeader;

	foreach ($files as $file) {
		$correctHeader = true;

		$fileContents = file_get_contents($file);
		$split = explode("\n", $fileContents);

		for ($i = 0; $i < sizeof($expectedHeaderSplit); $i++) {
			if ($correctHeader) {
				if ($expectedHeaderSplit[$i] != $split[$i]) {
					$correctHeader = false;
				}
			}
		}

		echo sprintf(
			"Checking '%s' [%s]%s",
			$file,
			$correctHeader ? 'Ok' : 'Fail',
			PHP_EOL
		);

		if (!$correctHeader) {
			echo sprintf("Starting repair of '%s'.%s", $file, PHP_EOL);

			// Create a new string
			$updatedFileContents = '';

			// Remove old headers...
			$nonCommentLineFound = false;

			// Walking trough the file starting now..
			for ($line = 0; $line < sizeof($split); $line++) {
				echo sprintf("Repairing line %s/%s of '%s'.\r", $line, sizeof($split), $file);
				usleep(500);

				if ($line == 0 && substr($split[$line], 0, 2) != "//") {
					$nonCommentLineFound = true;
				}

				if (!$nonCommentLineFound) {
					// Check if the 'HEADER' is filled with comments.
					if (substr($split[$line], 0, 2) != "//") {
						// The comments seems to be gone
						$nonCommentLineFound = true;

						// Add non 'HEADER' line to the new file
						$updatedFileContents .= $split[$line] . "\n";
					}
				} else {
					if ($line != (sizeof($split) - 1)) {
						// Add non 'HEADER' line to the new file
						$updatedFileContents .= $split[$line] . "\n";
					}
				}
			}

			$correctHeader = true;
			$newFileContents = $expectedHeader . PHP_EOL . $updatedFileContents;
			$explodedNewFileContents = explode("\n", $newFileContents);

			for ($i = 0; $i < sizeof($expectedHeaderSplit); $i++) {
				if ($correctHeader) {
					if ($expectedHeaderSplit[$i] != $explodedNewFileContents[$i]) {
						$correctHeader = false;
					}
				}
			}

			echo sprintf(
				"Rechecking '%s' repair %s.%sSaving to '%s'.%s",
				$file,
				$correctHeader ? 'sucess' : 'failed',
				PHP_EOL,
				$file,
				PHP_EOL
			);

			file_put_contents($file, $newFileContents);
		}
	}
}

?>