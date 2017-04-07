`
import { APP_BASE_HREF } from '@angular/common';
import { enableProdMode, NgModule,  Component} from '@angular/core';
import { BrowserModule }  from '@angular/platform-browser';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import { RouterModule, Routes, Router } from '@angular/router';
`


PageNotFoundComponent = class PageNotFoundComponent 

PageNotFoundComponent.annotations = [
	new Component
		template: '<h2>Page not found</h2>'
]


PopupComponent = class PopupComponent

	constructor: (@router) ->

	closePopup: ->
		@router.navigate([{ outlets: { popup: null }}])


PopupComponent.parameters = [
	[Router]
]

PopupComponent.annotations = [
	new Component
		template: '<h3>Popup</h3><button (click)="closePopup()">Close</button>'
		styles: [ ':host { position:absolute;top:100px;padding:20px;left:100px;opacity:0.8;width:500px;height:500px;background:green;}' ]
]


AppComponent = class AppComponent

AppComponent.annotations = [
	new Component
		selector: 'main'
		styles: [':host /deep/ *{ font: 18px Arial !important; }'],
		template: """
			<nav>
				<a routerLink="/welcome" routerLinkActive="active">Welcome</a>
				<a [routerLink]="['/home',{ outlets: { pages: ['home'] } }]" routerLinkActive="active">Home</a>
				<a [routerLink]="[{ outlets: { popup: ['message'] } }]">Popup</a>
			</nav>
			<router-outlet></router-outlet>
			<router-outlet name="pages"></router-outlet>
			<router-outlet name="popup"></router-outlet>
		"""
]




appRoutes = [
	{
		path: 'welcome'
		loadChildren: -> new Promise(((resolve) ->
			require.ensure [], (require) ->
				resolve(require('./welcome/welcome.coffee')['WelcomeModule'])
		), 'welcome')
	}
	{
		path: 'home'
		loadChildren: -> new Promise(((resolve) ->
			require.ensure [], (require) ->
				resolve(require('./home/home.coffee')['HomeModule'])
		), 'home')
	}
	{
    path: 'message',
    outlet: 'popup',
    component: PopupComponent,
  
  },
	{
		path: ''
		redirectTo: '/home'
		pathMatch: 'full'
	}
	{
		path: '**'
		component: PageNotFoundComponent
	}
]

AppModule = class AppModule

AppModule.annotations = [

	new NgModule
		 providers: [
				{
					provide: APP_BASE_HREF
					useValue: '/'
				}
			]
			imports: [
				BrowserModule
				RouterModule.forRoot(appRoutes)
			]
			declarations: [
				AppComponent
				PageNotFoundComponent
				PopupComponent
			]
			bootstrap: [ AppComponent ]

]





document.addEventListener 'DOMContentLoaded', (event) ->
	console.log 'App init', 'ENV ' + process.env.ENV
	platformBrowserDynamic().bootstrapModule(AppModule)
	return
