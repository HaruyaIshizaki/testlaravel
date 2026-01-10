<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/layout/home', function () {
    return view('pages.home');
});

Route::get('/layout/about', function () {
    return view('pages.about');
});

Route::get('/layout/contact', function () {
    return view('pages.contact');
});
