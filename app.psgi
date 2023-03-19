use strict;
use warnings;
use Carp;

use Plack::App::Path::Router::PSGI;
use Path::Router;
use Plack::Request;
use DBI;

my $router = Path::Router->new;
$router->add_route( '/'         => target => \&root );
$router->add_route( '/finish'      => target => \&finish );
$router->add_route( '/confirm'      => target => \&confirm );

# create Plack app
my $app = Plack::App::Path::Router::PSGI->new( router => $router );
$app->to_app();

# アンケート
sub root {
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
    <form method="POST" action="/confirm" enctype="multipart/form-data"><p>
    <li><input type="text" name="user_name" placeholder="氏名" required></li>
    <li><input type="text" name="user_age" placeholder="年齢" required></li>
    <li>
    <input type="radio" name="user_work" value="会社員" checked>会社員
    <input type="radio" name="user_work" value="自営業">自営業
    <input type="radio" name="user_work" value="学生">学生
    <input type="radio" name="user_work" value="主婦（夫）">主婦（夫）
    <input type="radio" name="user_work" value="主その他">その他
    </li>
    <li>
	<label>よく飲むお酒</label>
	<label for="beer">ビール <input id="beer" type="checkbox" name="drink1" value="ビール"></label>
	<label for="wine">ワイン <input id="wine" type="checkbox" name="drink2" value="ワイン"></label>
	<label for="champagne">シャンパン <input id="champagne" type="checkbox" name="drink3" value="シャンパン"></label>
	<label for="sake">日本酒 <input id="sake" type="checkbox" name="drink4" value="日本酒"></label>
    <label for="shaoxing">紹興酒 <input id="shaoxing" type="checkbox" name="drink5" value="紹興酒"></label>
    <label for="shochu">焼酎 <input id="shochu" type="checkbox" name="drink6" value="焼酎"></label>
    <label for="whisky">ウイスキー <input id="whisky" type="checkbox" name="drink7" value="ウイスキー"></label>
    </li>
    <li>
    <input type="text" name="about_drink" placeholder="その他、お酒に関するこだわり">
    </li>
    <button type="submit">回答する</button>
    </p></form>
</ul>
</form>
</body>
</html>
END
}

# 確認ページ
sub confirm {
    my $env = shift;
    my $req = Plack::Request->new($env);
    my $method = $req->method;
    my $title = 'アンケートフォーム';

    my $action = $req->body_parameters->{'user_name'};
    my $id = $req->body_parameters->{'user_age'};
    my $userWork = $req->body_parameters->{'user_work'} || '';
    my $favDrink1 = $req->body_parameters->{'drink1'} || '';
    my $favDrink2 = $req->body_parameters->{'drink2'} || '';
    my $favDrink3 = $req->body_parameters->{'drink3'} || '';
    my $favDrink4 = $req->body_parameters->{'drink4'} || '';
    my $favDrink5 = $req->body_parameters->{'drink5'} || '';
    my $favDrink6 = $req->body_parameters->{'drink6'} || '';
    my $favDrink7 = $req->body_parameters->{'drink7'} || '';
    my $aboutDrink = $req->body_parameters->{'about_drink'} || '';
    return response( $env, <<"END" );
<!DOCTYPE html>
<html lang="ja">
<head>
        <meta charset="utf-8">
        <title>$title</title>
</head>
<body>
<h1>回答内容</h1>
<form method="POST" action="/finish" enctype="multipart/form-data"><p>
    氏名: $action
    年齢: $id
    職業: $userWork
    よく飲むお酒: $favDrink1 $favDrink2 $favDrink3 $favDrink4 $favDrink5 $favDrink6 $favDrink7
    お酒のこだわり: $aboutDrink
    <input type="hidden" name="user_name" value="$action">
    <input type="hidden" name="user_age" value="$id">
    <input type="hidden" name="user_work" value="$userWork">
    <input type="hidden" name="drink1" value="$favDrink1">
    <input type="hidden" name="drink2" value="$favDrink2">
    <input type="hidden" name="drink3" value="$favDrink3">
    <input type="hidden" name="drink4" value="$favDrink4" >
    <input type="hidden" name="drink5" value="$favDrink5" >
    <input type="hidden" name="drink6" value="$favDrink6" >
    <input type="hidden" name="drink7" value="$favDrink7" >
    <input type="hidden" name="about_drink" value="$aboutDrink">
    <button type="submit">上記の内容で回答</button>
</p></form>

<hr>

<p><a href="/">トップに戻る</a></p>
</body>
</html>
END
}

# DB登録、回答完了ページ
sub finish {
    my $env = shift;
    my $req = Plack::Request->new($env);
    # MySQL
    our $DB_NAME = "surveyApp";
    our $DB_USER = "root";
    our $DB_PASS = "sqlPass";
    our $DB_HOST = "localhost";
    our $DB_PORT = "3306";

    my $dbh = DBI->connect("dbi:mysql:dbname=$DB_NAME;host=$DB_HOST;port=$DB_PORT","$DB_USER","$DB_PASS") or die "$!\n Error: failed to connect to DB.\n";
    
    # SQL処理
    my $userName = $req->body_parameters->{'user_name'};
    my $userAge = $req->body_parameters->{'user_age'};
    my $userWork = $req->body_parameters->{'user_work'};
    my $favDrink1 = $req->body_parameters->{'drink1'};
    my $favDrink2 = $req->body_parameters->{'drink2'};
    my $favDrink3 = $req->body_parameters->{'drink3'};
    my $favDrink4 = $req->body_parameters->{'drink4'};
    my $favDrink5 = $req->body_parameters->{'drink5'};
    my $favDrink6 = $req->body_parameters->{'drink6'};
    my $favDrink7 = $req->body_parameters->{'drink7'};
    my $aboutDrink = $req->body_parameters->{'about_drink'};
    my $sth = $dbh->prepare("insert into tb1(name, age, work, drink1, drink2, drink3, drink4, drink5, drink6, drink7, aboutDrink) 
    values('$userName', '$userAge', '$userWork', '$favDrink1', '$favDrink2', '$favDrink3', '$favDrink4', '$favDrink5', '$favDrink6', '$favDrink7', '$aboutDrink')");
    $sth->execute;
    $sth->finish();
    
    # SQL処理完了
    $dbh->disconnect;
    return response( $env, <<"END" );
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="utf-8">
    <title>アンケート回答完了</title>
</head>
<body>
    <h1>アンケートの回答が完了いたしました。</h1>
    <p><a href="/">トップに戻る</a></p>
</body>
</html>
END
}

# サブルーチン
sub response {
    my $env = shift;
    my $body = shift || croak 'empty body!';
    my %ARG = @_ if @_;
    my $status = $ARG{'-status'} || 200;
    croak "unvalid status: $status" if $status !~ /^\d{3}$/s;
    my $mime = $ARG{'-MIME'} || 'text/html; charset=utf-8';
    my $req = Plack::Request->new($env);
    my $res = $req->new_response($status);
    $res->content_type($mime);
    $res->body($body);
    $res->finalize;
}