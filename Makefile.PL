use 5.030000;
use ExtUtils::MakeMaker;


WriteMakefile(
    NAME              => 'App::NetkitGui',
    VERSION_FROM      => 'bin/netkitgui',
    PREREQ_PM         => {
    	'strict' => 0,
    	'warnings' => 0,
    	'Glib::IO' => 0.002,
    	'Gtk3' => 0.038,
    	'Glib::Object::Introspection' => 0.049,
    	'Cairo::GObject' => 1.005,
    },
    ABSTRACT_FROM     => 'bin/netkitgui', # retrieve abstract from module
    EXE_FILES         => ['bin/netkitgui'],
    AUTHOR            => 'Rhys Adams <rhys@therhys.co.uk>',
    LICENSE           => 'perl',
);
