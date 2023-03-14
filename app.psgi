use strict;
use warnings;
use Path::Router;
use Plack::Request;

my $app = sub {
    my $env = shift;
    return [
        200,
        [ 'Content-Type' => 'text/plain' ],
        [ "Hello World" ],
        ];
};

sub top {
    my $env = shift;
    my $title = 'アンケートフォーム';
    return response( $env, <<"END");
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="utf-8">
    <title>$title</title>
</head>
<body>
<h1>$title</h1>
<ul>
    <form method="POST" action=""><p>
    <input type="text" name="user_name" placeholder="氏名" required>
    <input type="text" name="user_age" placeholder="年齢" required>
    <input type="text" name="user_work" placeholder="職業">
    <div>
	<label>よく飲むお酒</label>
	<label for="beer">ビール <input id="beer" type="checkbox" name="drink1" value="ビール"></label>
	<label for="wine">ワイン <input id="wine" type="checkbox" name="drink2" value="ワイン"></label>
	<label for="champagne">シャンパン <input id="champagne" type="checkbox" name="drink3" value="シャンパン"></label>
	<label for="sake">日本酒 <input id="sake" type="checkbox" name="drink4" value="日本酒"></label>
    <label for="shaoxing">紹興酒 <input id="shaoxing" type="checkbox" name="drink5" value="紹興酒"></label>
    <label for="shochu">焼酎 <input id="shochu" type="checkbox" name="drink6" value="焼酎"></label>
    <label for="whisky">ウイスキー <input id="whisky" type="checkbox" name="drink7" value="ウイスキー"></label>
    </div>
    <input type="text" name="about_drink">
    <button type="submit">回答する</button>
    </p></form>
</ul>
</form>
</body>
</html>
END
}


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