set -e -o pipefail

# adb_tool_path="/usr/local/google/home/ktimofeev/Android/Sdk/platform-tools/adb"
# appt2_tool_path="/usr/local/google/home/ktimofeev/Android/Sdk/build-tools/35.0.0/aapt2"

# apk_path="/usr/local/google/home/ktimofeev/Work/simple-android-bazel-app/bazel-bin/app/src/main/app.apk"
# test_apk_path="/usr/local/google/home/ktimofeev/Work/simple-android-bazel-app/bazel-bin/app/src/test/my_test_app.apk"

adb_tool_path="%%adb_tool_path%%"
appt2_tool_path="%%appt2_tool_path%%"

apk_path="%%apk_path%%"
test_apk_path="%%test_apk_path%%"

apk_package=$("${appt2_tool_path}" dump packagename "${apk_path}")
test_apk_package=$("${appt2_tool_path}" dump packagename "${test_apk_path}")


function call_adb_uninstall() {
	local apk_pkg="$1"
	# adb uninstall exits with error if there is no package 'apk_pkg' installed.
	# this is fine for us: we try to delete a package first even if it is not installed
	set +e

	local res
	res=$("${adb_tool_path}" uninstall "${apk_pkg}" 2>&1)
	if [[ "$res" != "Failure [DELETE_FAILED_INTERNAL_ERROR]" ]] && [[ "$res" != "Success" ]]; then
		echo "adb uninstall error: '${res}'"
		exit 1
	fi

	set -e
}

call_adb_uninstall "${apk_package}"

call_adb_uninstall "${test_apk_package}"

"${adb_tool_path}" install "${apk_path}"

"${adb_tool_path}" install "${test_apk_path}"

adb shell am instrument -w "${test_apk_package}/androidx.test.runner.AndroidJUnitRunner"