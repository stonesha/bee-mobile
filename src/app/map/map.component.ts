import { environment } from '../../environments/environment';
import { Component, OnInit} from '@angular/core';
import * as mapboxgl from 'mapbox-gl'; 

@Component({
  selector: 'app-map',
  templateUrl: './map.component.html',
  styleUrls: ['./map.component.scss'],
})

export class MapComponent implements OnInit {

  map: mapboxgl.Map;
  style = 'mapbox://styles/mapbox/dark-v10';
  lat: 39.52766;
  lng: -119.81353;


  constructor() { }

  ngOnInit() {
      this.map = new mapboxgl.Map({
        accessToken: environment.mapbox.accessToken,
        container: 'map',
        style: this.style,
        zoom: 10,
        center: [this.lng, this.lat]
    });
    // Add map controls
    this.map.addControl(new mapboxgl.NavigationControl());
  }

}
