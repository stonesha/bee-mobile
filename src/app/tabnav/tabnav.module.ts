import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';

//importing routes and routermodule to create routes array
import { Routes, RouterModule } from '@angular/router';

import { TabnavPageRoutingModule } from './tabnav-routing.module';
import { TabnavPage } from './tabnav.page';

//declaring routes array and children routes
//for now the only tab/child nav is the map component
const routes: Routes = [
  {
    path: 'tab-nav',
    component: TabnavPage,
    children: [
      {
        path: 'map',
        loadChildren: '../map/map.module#MapPageModule'
      },
      {
        path: 'settings',
        loadChildren: '../settings/settings.module#SettingsPageModule'
      }
    ]
  },
  {
    path: '',
    redirectTo: '/tabs-nav/dashboard'
  }
];

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    TabnavPageRoutingModule,
    RouterModule.forChild(routes)
  ],
  declarations: [TabnavPage]
})
export class TabnavPageModule {}
