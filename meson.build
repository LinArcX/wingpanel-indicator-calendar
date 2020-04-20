project('com.github.linarcx.wingpanel-indicator-calendar', 'vala', 'c')

wingpanel_dep = dependency('wingpanel-2.0')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0'),
    meson.get_compiler('vala').find_library('posix'),
    wingpanel_dep
]

files = [
    'src/Main.vala',
    'src/Widgets/PanelLabel.vala',
    'src/Services/TimeManager.vala',
    'src/LibCalendar/SolarHijri.vala',
]

shared_module(
    meson.project_name(),
    files,
    dependencies: dependencies,
    install: true,
    #install_dir : wingpanel_dep.get_pkgconfig_variable('indicatorsdir')
    install_dir : '/usr/lib/wingpanel/'
)

subdir('data')

meson.add_install_script('meson/post_install.py')
