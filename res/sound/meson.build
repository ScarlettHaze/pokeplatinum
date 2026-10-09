# The sound archive is HGSS's (gs_sound_data.sdat, from pokeheartgold),
# unchanged. hgss_sound.py writes pl_sound_data.naix, which names its sounds
# by Platinum's names as well as HGSS's.

hgss_sound_py = find_program(meson.project_source_root() / 'tools/hgss_import/hgss_sound.py', native: true)

pl_sound_data_sdat = custom_target('pl_sound_data.sdat',
    build_by_default: true,
    input: [
        files('gs_sound_data.sdat'),
        files(meson.project_source_root() / 'tools/hgss_import/pl_sound_names.json'),
    ],
    output: [
        'pl_sound_data.sdat',
        'pl_sound_data.naix',
    ],
    depend_files: files(
        meson.project_source_root() / 'tools/hgss_import/hgss_sound.py',
        meson.project_source_root() / 'tools/hgss_import/sdat.py',
    ),
    command: [
        hgss_sound_py,
        '@INPUT0@', '@INPUT1@', '@OUTPUT0@', '@OUTPUT1@',
    ]
)

nitrofs_files += pl_sound_data_sdat
naix_headers += pl_sound_data_sdat[1]
