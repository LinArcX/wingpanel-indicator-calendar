icons_dir = join_paths(get_option('datadir'), 'icons', 'hicolor')

install_data(
		join_paths('assets', 'icons', 'saudi-arabia.svg'),
		install_dir: join_paths(icons_dir , 'scalable', 'apps')
)

install_data(
		join_paths('assets', 'icons', 'iran.svg'),
		install_dir: join_paths(icons_dir , 'scalable', 'apps')
)

install_data(
		join_paths('assets', 'icons', 'united-states.svg'),
		install_dir: join_paths(icons_dir , 'scalable', 'apps')
)

install_data(
	'assets/events/JSon/PersianNational.json',
	install_dir: join_paths(get_option('datadir'), 'wingpanel-indicator-calendar'),
)

install_data(
	'gschema.xml',
	install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas'),
	rename: meson.project_name() + '.gschema.xml'
)
