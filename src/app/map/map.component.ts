import { Component, OnInit, ChangeDetectorRef} from '@angular/core';
const mapboxgl = require('mapbox-gl'); //for some reason only way to fix read only error of accessToken, I don't know why

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
    mapboxgl.accessToken= process.env.MAPBOX_ACCESS_TOKEN;
      this.map = new mapboxgl.Map({
        container: 'map',
        style: this.style,
        zoom: 10,
        center: [this.lng, this.lat]
    });
    // Add map controls
    this.map.addControl(new mapboxgl.NavigationControl());
  }

}
