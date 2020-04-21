icons_dir = join_paths(get_option('datadir'), 'icons', 'hicolor')

# Copy icons
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

# Copy json files
install_data(
	'assets/events/PersianNational.json',
	install_dir: join_paths(get_option('datadir'), 'wingpanel-indicator-calendar'),
)
install_data(
	'assets/events/PersianSolar.json',
	install_dir: join_paths(get_option('datadir'), 'wingpanel-indicator-calendar'),
)
install_data(
	'assets/events/PersianLonar.json',
	install_dir: join_paths(get_option('datadir'), 'wingpanel-indicator-calendar'),
)
install_data(
	'assets/events/PersianPersonage.json',
	install_dir: join_paths(get_option('datadir'), 'wingpanel-indicator-calendar'),
)
install_data(
	'assets/events/World.json',
	install_dir: join_paths(get_option('datadir'), 'wingpanel-indicator-calendar'),
)


# Copy xml files
install_data(
	'gschema.xml',
	install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas'),
	rename: meson.project_name() + '.gschema.xml'
)
