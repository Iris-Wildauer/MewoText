import {Component, signal} from '@angular/core';
import {FormsModule} from "@angular/forms";
@Component({
  selector: 'app-input',
  imports: [
    FormsModule
  ],
  templateUrl: './input.html',
  styleUrl: './input.css',
})
export class Input {
  protected value: any;
  lineHeight = 20;
  charWidth  = 9.6;  // bei 16px monospace font
  cx = signal(0);
  cy = signal(0);
  text = signal<string[][]>([[]]);
  async sendInput(event: KeyboardEvent){
    event.preventDefault();
    const output = await (window as any).sendInput({cmd : event.key, row : 3, column : 8});
    //this.text.update((text) => [...text[output[0].row][output[0].column], output[0].cmd]);
    this.text.update(text => {
    const t = text.map(r => [...r]);

    while (t.length <= output[0].row) t.push([]);
    while (t[output[0].row].length <= output[0].column) t[output[0].row].push(' ');

    t[output[0].row][output[0].column] = output[0].cmd;
    return t;
    });
  }
}
