`
import { ModuleWithProviders } from '@angular/core';
import { Routes, RouterModule } from '@angular/router'
import { Component } from '@angular/core';
import { NgModule } from '@angular/core';
`


HomeComponent = class HomeComponent

	constructor: ->
		@test = 'Wow'

HomeComponent.annotations = [
	new Component
		template: require('./home.pug')()
		styles: ['h2 { color: green; }']
]

routes = [
	{ path: '', outlet: 'pages', component: HomeComponent }
]

routing = RouterModule.forChild(routes);


HomeModule = class HomeModule

HomeModule.annotations = [

	new NgModule
		imports: [routing]
		declarations: [HomeComponent]

]


`export {routing}`
`export {HomeComponent}`
`export {HomeModule}`




