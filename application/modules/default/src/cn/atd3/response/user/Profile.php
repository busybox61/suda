<?php
namespace cn\atd3\response\user;

use suda\core\Request;
use suda\core\Session;
use suda\core\Cookie;

// Auto generate response class
class Profile extends \suda\core\Response {
    public function onRequest(Request $request){
        //Auto create params getter ...
		$user=$request->get()->user("hello!");

        $this->display('default:user\profile',['helloworld'=>'Hello,World!']);
    }
}