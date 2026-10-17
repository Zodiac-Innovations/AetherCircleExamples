#!/usr/bin/env python3
"""Check that the Quest APK contains current shared resources and runtime libraries."""
from pathlib import Path
import sys
import zipfile

root = Path(__file__).resolve().parent
apk = Path(sys.argv[1]) if len(sys.argv) > 1 else root / 'app/build/outputs/apk/debug/app-debug.apk'
resources = root.parent / 'Shared/Files'
with zipfile.ZipFile(apk) as archive:
    names = set(archive.namelist())
    count = 0
    for source in sorted(resources.rglob('*')):
        if not source.is_file() or any(p.startswith('.') for p in source.relative_to(resources).parts):
            continue
        asset = 'assets/aethercircle/' + source.relative_to(resources).as_posix()
        if asset not in names or archive.read(asset) != source.read_bytes():
            raise RuntimeError('Missing or stale packaged resource: ' + asset)
        count += 1
    for library in ('libAetherCircleQuestApp.so', 'libswiftCore.so', 'libBlocksRuntime.so', 'libdispatch.so'):
        if 'lib/arm64-v8a/' + library not in names:
            raise RuntimeError('Missing ARM64 runtime library: ' + library)
print(f'APK verified: {count} shared resources match exactly; required ARM64 runtime libraries present.')
