package NetkitGui::MachineWidget;

use warnings;
use strict;

use Env qw(HOME NETKIT_HOME);
use Cwd;

use Glib::IO;
use NetkitGui::Vte;
use Gtk3;

sub new {
	my $class = shift;
	my ($lab, $machine, $num_ttys, $engine, $headerbar) = @_;

	my $self = Gtk3::Box->new('vertical', 5);
	
	$self->{tty_notebook} = Gtk3::Notebook->new();

	for my $id (0..($num_ttys-1)) {
		my $label = Gtk3::Label->new("TTY$id");
		my $term;

		if($engine =~ /netkit/i) {
			$term = &new_netkit($self, $machine);
		} elsif($engine =~ /kathara/i) {
			$term = &new_kathara($self, $machine);
		} else {
			die "Unknown engine: '$engine'";
		}
		
		$self->{tty_notebook}->append_page($term, $label);
		$self->{tty_notebook}->child_set($term, tab_expand => 1);
	}

	$self->add($self->{tty_notebook});

	return $self;
}

sub new_kathara {
	my $class = shift;
	my ($machine) = @_;

	&get_term("/bin/kathara", "connect", "$machine");
}

sub new_netkit {
	my $class = shift;
	my ($machine) = @_;

	&get_term("$NETKIT_HOME/bin/vconnect", "$machine");
}

sub get_term {
	my @cmds = @_;
	
	my $out = Vte::Terminal->new;
	my $gsettings = Gtk3::Settings::get_default;
	
	my $style_context = $out->get_style_context;
	my $fg = $style_context->get_color($style_context->get_state);
	my $bg = $style_context->get_background_color($style_context->get_state);
	
	$out->set_colors($fg, $bg, []);
	
	$out->signal_connect(key_press_event => sub {
		my ($widget, $evt) = @_;
		
		my $key = $evt->keyval;
		my $ctrl = $evt->state & 'control-mask';
		
		# KEY_C == uppercase 'C', so includes the shift also. Lowercase 'c' would be KEY_c.
		if($ctrl && ($key == Gtk3::Gdk::KEY_C)){
			$out->copy_clipboard();
			return 1;
		} elsif ($ctrl && ($key == Gtk3::Gdk::KEY_V)){
			$out->paste_clipboard();
			return 1;
		}
		
		return 0;
	});
	
	$out->spawn_sync (
		'default',
		&getcwd,
		\@cmds,
		[],
		'default',
	);
	
	$out->set_vexpand(1);
	$out->set_hexpand(1);
	
	return $out;
}

1;
