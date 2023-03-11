package NetkitGui::MainWindow;

use warnings;
use strict;

use Env qw(HOME);

use Glib::IO;
use Vte;
use Gtk3 -init;

use MachineWidget;

sub new {
	my $class = shift;
	
	my $lab = shift;
	my $headerbar = shift // 1;
	
	my $self = bless {
		lab => $lab,
		headerbar => $headerbar
	}, $class;

	return $self;
}

sub activate {
	my $class = shift;
	
	$class->{win} = Gtk3::ApplicationWindow->new($class->{app});
	
	if($class->{headerbar}){
		my $header = Gtk3::HeaderBar->new();
		$header->set_show_close_button(1);
		$class->{win}->set_titlebar($header);
	}
	
	$class->{main_notebook} = Gtk3::Notebook->new();
	$class->{main_notebook}->signal_connect(create_window => sub {$class->notebook_create_window($class->{main_notebook})});
	$class->{main_notebook}->set_group_name('0');
	
	for my $machine ($class->{lab}->machines) {
		my $label = Gtk3::Label->new("$machine");
		
		my $widget = MachineWidget->new($class->{lab}, $machine, $class->{headerbar});

		$class->{main_notebook}->append_page($widget, $label);
		
		$class->{main_notebook}->set_tab_reorderable($widget, 1);
		$class->{main_notebook}->set_tab_detachable($widget, 1);
		$class->{main_notebook}->child_set($widget, tab_expand => 1);
	}

	$class->{win}->add($class->{main_notebook});
	$class->{win}->show_all();
}

sub notebook_create_window {
	my $class = shift;
	my ($main_notebook) = @_;
	
	my $win = Gtk3::Window->new();
	
	my $header = Gtk3::HeaderBar->new();
	$header->set_show_close_button(1);
	$win->set_titlebar($header);
	
	my $notebook = Gtk3::Notebook->new();
	$notebook->set_group_name('0');
	$win->add($notebook);
	
	$notebook->signal_connect(page_removed => sub {$class->page_removed(@_, $win)});
	
	$win->signal_connect(destroy => sub {$class->sub_win_destroy(@_, $notebook, $main_notebook)});

	$win->set_destroy_with_parent(1);
        $win->set_size_request(400, 400);
	
	$win->show_all();
	
	return $notebook;
}

sub page_removed {
	my $class = shift;
	my ($notebook, $child, $page, $window) = @_;
	
	if($notebook->get_n_pages == 0) {
		$window->destroy();
	}
}

sub sub_win_destroy {
	my $class = shift;
	my ($window, $current_notebook, $original_notebook) = @_;
	
	for (my $i=$current_notebook->get_n_pages()-1 ; $i >= 0 ; $i--) {		
		my $widget = $current_notebook->get_nth_page($i);
		my $label = $current_notebook->get_tab_label($widget);
		
		$current_notebook->detach_tab($widget);
		$original_notebook->append_page($widget, $label);
		
		$original_notebook->set_tab_detachable($widget, 1);
		$original_notebook->set_tab_reorderable($widget, 1);
		$original_notebook->child_set($widget, tab_expand => 1);
	}
}

sub run {
	my $class = shift;

	$class->{app} = Gtk3::Application->new('uk.co.therhys.NetkitGui', 'flags-none');

	$class->{app}->signal_connect( activate => sub { $class->activate; } );

	$class->{app}->run();
}

1;
