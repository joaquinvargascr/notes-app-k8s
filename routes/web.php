<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\NoteController;

Route::get('/', [NoteController::class, 'index'] );

Route::resource('notes', NoteController::class);
