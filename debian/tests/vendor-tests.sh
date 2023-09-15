#!/bin/sh

set -e

cp debian/tests/dh-cargo-vendor-test* $AUTOPKGTEST_TMP
cd $AUTOPKGTEST_TMP
dpkg-source --no-check -x dh-cargo-vendor-test_0.0.1-1.dsc

cd dh-cargo-vendor-test-0.0.1
cp debian/control.valid-field debian/control

dpkg-buildpackage

cp debian/control.no-field debian/control
if dpkg-buildpackage 2> ../error_logs; then
    echo "This test should have failed!"
    exit 1
fi
grep -q "XS-Vendored-Sources-Rust" ../error_logs

cp debian/control.bad-version debian/control
if dpkg-buildpackage 2> ../error_logs; then
    echo "This test should have failed!"
    exit 1
fi
grep -q "XS-Vendored-Sources-Rust" ../error_logs
