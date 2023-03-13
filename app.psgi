use strict;
use warnings;

my $app = sub {
    my $env = shift;
    return [
        200,
        [ 'Content-Type' => 'text/plain' ],
        [ "Hello World" ],
        ];
};

sub dbSession {
    my $env = shift;

    # MySQL
    our $DB_NAME = "mysql";
    our $DB_USER = "root";
    our $DB_PASS = "sqlPass";
    our $DB_HOST = "localhost";
    our $DB_PORT = "3306";

    my $dbh = DBI->connect("dbi:mysql:dbname=$DB_NAME;host=$DB_HOST;port=$DB_PORT","$DB_USER","$DB_PASS") or die "$!\n Error: failed to connect to DB.\n";
    
    # SQL処理
    $sth->execute;
    $sth->finish();
    
    # SQL処理完了
    $dbh->disconnect;
}

return  $app;