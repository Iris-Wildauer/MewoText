import { Component, signal } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import {Input} from "./input/input";
@Component({
  selector: 'app-root',
  imports: [RouterOutlet, Input],
  templateUrl: './app.html',
  styleUrl: './app.css'
})
export class App {
  protected readonly title = signal('MewoText');
}
