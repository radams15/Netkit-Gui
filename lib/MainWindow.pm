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
	
	$class->{win} = Gtk4::ApplicationWindow->new($class->{app});
	
	my $header = Gtk4::HeaderBar->new();
	
	$class->{win}->set_titlebar($header);
	
	$class->{main_notebook} = Gtk4::Notebook->new();
	$class->{main_notebook}->signal_connect(create_window => sub {$class->notebook_create_window});
	$class->{main_notebook}->set_group_name('0');
	
	for my $machine ($class->{lab}->machines) {
		my $label = Gtk4::Label->new("$machine");
		
		my $widget = MachineWidget->new($class->{lab}, $machine);

		$class->{main_notebook}->append_page($widget, $label);
		
		$class->{main_notebook}->set_tab_detachable($widget, 1);
	}

	$class->{win}->set_child($class->{main_notebook});
	$class->{win}->present();
}

sub notebook_create_window {
	my $class = shift;
	my ($main_notebook, $widget) = @_;
	
	my $win = Gtk4::Window->new();
	my $notebook = Gtk4::Notebook->new();
	$notebook->set_group_name('0');
	$win->set_child($notebook);
	
	$notebook->signal_connect(page_removed => sub {$class->page_removed(@_, $win)});
	
	$win->signal_connect(destroy => sub {$class->sub_win_destroy(@_, $notebook, $main_notebook)});
	$win->set_transient_for($class->{win});
	$win->set_destroy_with_parent(1);
	
	$win->present();
	
	return $notebook;
}

sub page_removed {
	my $class = shift;
	my ($notebook, $child, $page, $window) = @_;
	
	if($notebook->get_n_pages == 0) {
		$window->destroy();
	}
}

sub run {
	my $class = shift;
	
	$class->{app} = Gtk4::Application->new('com.example.App', 'flags-none');

	$class->{app}->signal_connect( activate => sub { $class->activate; } );

	$class->{app}->run();
}

1;
