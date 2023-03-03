package Lab;

use warnings;
use strict;

use Cwd;
use Env qw(HOME);

sub new {
	my $class = shift;
	my ($dir) = shift;
	
	my $self = bless {
		dir => $dir,
	}, $class;

	return $self;
}


sub start {
	my $class = shift;
	
	my $dir = shift;
	my $port_start = shift // 5000;
	
	my $start_dir = getcwd;
	
	chdir $dir;
	
	system("lstart --port-start $port_start");
	
	chdir $start_dir;
}

sub machines {
	my $class = shift;
	
	my $root = $class->{dir};
	
	my @out = ();
	
	for (<$root/*/>){
		s/$root//g;
		s/\/(.*?)\//$1/g; # Get the lab name.
		
		push @out, $_;
	}
	
	return @out;
}

sub machine_ttys {
	my $class = shift;
	my $machine = shift;
	
	my $root = $class->{dir};
	
	my %out = ();
	
	for my $path (<$HOME/.netkit/machines/$machine/port.tty*>) {
		my $id;
		if($path =~ /$HOME\/\.netkit\/machines\/$machine\/port\.tty(\d+)/g) { # Just extract tty id.
			$id = $1;
		}
		
		open FH, '<', $path;
		
		chomp(@out{$id} = <FH>);
		
		close FH;
	}
	
	return %out;
}


1;
