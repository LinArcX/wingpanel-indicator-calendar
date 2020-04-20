project(
    'datetime',
    'vala', 'c',
    version: '2.2.2'
)

project('com.github.linarcx.wingpanel-indicator-calendar', 'vala', 'c')

i18n = import('i18n')
gnome = import('gnome')
prefix = get_option('prefix')
libdir = join_paths(prefix, get_option('libdir'))
wingpanel_dep = dependency('wingpanel-2.0')
wingpanel_indicatorsdir = wingpanel_dep.get_pkgconfig_variable('indicatorsdir', define_variable: ['libdir', libdir])

gresource = gnome.compile_resources(
    'gresource',
    join_paths('data', 'datetime.gresource.xml'),
    source_dir: 'data'
)

shared_module(
    meson.project_name(),
    gresource,

    'src/Main.vala',
    'src/Widgets/PanelLabel.vala',
    'src/Services/TimeManager.vala',
    'src/LibCalendar/SolarHijri.vala',

    dependencies: [
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('granite'),
        dependency('gtk+-3.0'),
        meson.get_compiler('vala').find_library('posix'),
        wingpanel_dep,
    ],

    install: true,
    #install_dir : wingpanel_indicatorsdir,
    install_dir : '/usr/lib/wingpanel/',
)

subdir('data')
meson.add_install_script('meson/post_install.py')
