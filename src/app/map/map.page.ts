import { environment } from '../../environments/environment';
import { Component, OnInit } from '@angular/core';
import * as mapboxgl from 'mapbox-gl';
import MapboxDirections from '@mapbox/mapbox-gl-directions/dist/mapbox-gl-directions';

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

    var directions = new MapboxDirections({
      accessToken: environment.mapbox.accessToken
    });

    //considers congestion of traffic when calculating a route
    directions.congestion = true;

    this.map.addControl(directions, 'top-left');

    this.map.on('load', (event) => {
      this.map.resize();
    });
  }

}
