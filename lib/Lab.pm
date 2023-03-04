package Lab;

use warnings;
use strict;

use Cwd;
use Env qw(HOME);
use List::Util qw(any);

sub new {
	my $class = shift;
	my $dir = shift;
	
	my $self = bless {
		dir => $dir,
	}, $class;

	return $self;
}

sub is_started {
	my $class = shift;
	
	my @machines = $class->machines();
	
	# Gets list of running machine names in ~/.netkit/machines/. Regex removes path.
	my @running = map { $_ =~ /$HOME\/\.netkit\/machines\/(.*?)\//g ? $1 : undef } <$HOME/.netkit/machines/*/>;
	
	for my $machine (@machines) {				
		if(! (any {$_ eq $machine} @running)) {
			return 0;
		}
	}
	
	return 1;
}


sub start {
	my $class = shift;
	
	my $port_start = shift // 5000;
	
	my $start_dir = getcwd;
	
	chdir $class->{dir};
	
	system("lstart --pass=--con0=none --port-start $port_start");
	
	chdir $start_dir;
}

sub stop {
	my $class = shift;
	
	my $start_dir = getcwd;
	
	chdir $class->{dir};
	
	system("lcrash");
	
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
