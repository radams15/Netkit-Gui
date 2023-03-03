package MainWindow;

use warnings;
use strict;

use Env qw(HOME);

use Glib::IO;
use Vte;
use Gtk4;

use MachineWidget;

sub new {
	my $class = shift;
	
	my $lab = shift;
	
	my $self = bless {
		lab => $lab
	}, $class;

	return $self;
}

sub activate {
	my $class = shift;
	
	my $win = Gtk4::ApplicationWindow->new($class->{app});
	
	my $header = Gtk4::HeaderBar->new();
	
	$win->set_titlebar($header);
	
	$class->{main_notebook} = Gtk4::Notebook->new();
	
	for my $machine ($class->{lab}->machines) {
		my $label = Gtk4::Label->new("$machine");
		
		my $widget = MachineWidget->new($class->{lab}, $machine);

		$class->{main_notebook}->append_page($widget, $label);
	}

	$win->set_child($class->{main_notebook});
	$win->present();
}

sub run {
	my $class = shift;
	
	$class->{app} = Gtk4::Application->new('com.example.App', 'flags-none');

	$class->{app}->signal_connect( activate => sub { $class->activate; } );

	$class->{app}->run();
}

1;
