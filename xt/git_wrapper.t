use strict;
use warnings;

use Path::Tiny;
use Git::Wrapper;
use Encode;

use Data::Dumper;

my $root = '/home/helmutw/github/Jane-Doe';

my $git = Git::Wrapper->new("$root");

my @quoted_files = qw(
share/Jane_Doe.txt
"share/Jane_Do\314\210.txt"
"share/Jane_D\303\266.txt"
"share/Jan\320\265_D\303\266.txt"
"share/J\320\260ne_D\303\266.txt"
"share/\320\210ane_D\303\266.txt"
);



my @git_files = $git->ls_files();

# git config core.quotepath false
# git config core.quotepath true
print STDERR '@git_files: ',Dumper(\@git_files),"\n";

my @git_config = $git->config('-l');

my ($quotedpath) = grep { /core\.quotepath=true/ } @git_config;

print STDERR '$quotedpath: ',$quotedpath,"\n";

print STDERR '@git_config: ',Dumper(\@git_config),"\n";


my $encoding = 'UTF-8';

for my $filename (@git_files) {
  if ($quotedpath && $filename =~ m/^"(.+)"$/) {
    $filename = eval "$filename";
    $filename =~s/^"|"$//g;   
  }
  
  $filename = decode( $encoding, $filename ); 
  print STDERR '$filename: ',Dumper(\$filename),"\n"; 
}

