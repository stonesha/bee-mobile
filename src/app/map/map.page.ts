import { environment } from '../../environments/environment';
import { Component, OnInit } from '@angular/core';
import * as mapboxgl from 'mapbox-gl';

@Component({
  selector: 'app-map',
  templateUrl: './map.page.html',
  styleUrls: ['./map.page.scss'],
})
export class MapPage implements OnInit {

  map: mapboxgl.Map;
  style = "mapbox://styles/mapbox/dark-v10";
  lat = 39.52766;
  lng = -119.81353;

  constructor() { }

  ngOnInit() {
  }

  ionViewDidEnter() {
    
    this.map = new mapboxgl.Map({
      accessToken: environment.mapbox.accessToken,
      container: 'map',
      style: this.style,
      zoom: 13,
      center: [this.lng, this.lat]
    });

    this.map.addControl(new mapboxgl.NavigationControl());
  }

}
