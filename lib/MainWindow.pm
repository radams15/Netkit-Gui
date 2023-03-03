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
	
	$class->{main_notebook} = Gtk4::Notebook->new();
	
	for my $machine ($class->{lab}->machines) {
=pod
		my @ttys = $class->{lab}->machine_ttys($machine);
		
		my $tty1 = $ttys[1];
		
		my $term = &get_term("telnet", "localhost", $tty1);
		
		my $label = Gtk4::Label->new("$machine tty1");
=cut

		my $label = Gtk4::Label->new("$machine");
		
		my $widget = MachineWidget->new($class->{lab}, $machine);

		$class->{main_notebook}->append_page($widget, $label);
	
		print "$machine\n";
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
