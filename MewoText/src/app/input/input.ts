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
  text = signal('');
  async sendInput(event: KeyboardEvent){
    event.preventDefault();
    const output = await (window as any).sendInput({cmd : event.key, char : 10});
    this.text.update((text) => text + output);
    console.log(output);
  }
  async onSearchChange(searchValue: string) :Promise<void> {
    const output = await (window as any).onSearchChange(searchValue);
    console.log(output);
  }
}
