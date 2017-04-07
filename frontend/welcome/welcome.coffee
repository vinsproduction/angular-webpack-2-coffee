`
import { ModuleWithProviders } from '@angular/core';
import { Routes, RouterModule } from '@angular/router'
import { Component } from '@angular/core';
import { NgModule } from '@angular/core';
`

WelcomeComponent = class WelcomeComponent

	constructor: ->
		@test = '1'

	do: ->
		@test++


WelcomeComponent.annotations = [
	new Component
		template: require('./welcome.pug')(),
		styles: ['h2 { color: red; } ']
]



routes = [
	{ path: '', component: WelcomeComponent }
]

routing = RouterModule.forChild(routes);


WelcomeModule = class WelcomeModule

WelcomeModule.annotations = [

	new NgModule
		imports: [routing]
		declarations: [WelcomeComponent]

]


`export {routing}`
`export {WelcomeComponent}`
`export {WelcomeModule}`
