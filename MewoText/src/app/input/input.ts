import {Component, signal} from '@angular/core';
import {FormsModule} from "@angular/forms";

@Component({
  selector: 'app-input',
  imports: [FormsModule],
  templateUrl: './input.html',
  styleUrl: './input.css',
})
export class Input {
  lineHeight = 20;
  cx = signal(0);
  cy = signal(0);
  text = signal<string[][]>([[]]);

  async sendInput(event: KeyboardEvent) {
    event.preventDefault();

    await (window as any).sendInput({
      cmd:    event.key,
      row:    this.cy(),
      column: this.cx()
    });

    switch (event.key) {
      case 'Backspace':
        this.deleteCharBefore();
        break;
      case 'Delete':
        this.deleteCharAt();
        break;
      case 'Enter':
        this.insertNewline();
        break;
      case 'ArrowLeft':
        this.cx.update(x => Math.max(0, x - 1));
        break;
      case 'ArrowRight': {
        const len = this.text()[this.cy()]?.length ?? 0;
        this.cx.update(x => Math.min(len, x + 1));
        break;
      }
      case 'ArrowUp':
        if (this.cy() > 0) {
          this.cy.update(y => y - 1);
          this.clampCx();
        }
        break;
      case 'ArrowDown':
        if (this.cy() < this.text().length - 1) {
          this.cy.update(y => y + 1);
          this.clampCx();
        }
        break;
      default:
        if (event.key.length === 1) {
          this.insertChar(event.key);
        }
    }
  }

  private clampCx() {
    const len = this.text()[this.cy()]?.length ?? 0;
    this.cx.update(x => Math.min(x, len));
  }

  private insertChar(c: string) {
    const cx = this.cx();
    const cy = this.cy();
    this.text.update(text => {
      const t = text.map(r => [...r]);
      while (t.length <= cy) t.push([]);
      t[cy].splice(cx, 0, c);
      return t;
    });
    this.cx.update(x => x + 1);
  }

  private deleteCharBefore() {
    const cx = this.cx();
    const cy = this.cy();
    if (cx > 0) {
      this.text.update(text => {
        const t = text.map(r => [...r]);
        t[cy].splice(cx - 1, 1);
        return t;
      });
      this.cx.update(x => x - 1);
    } else if (cy > 0) {
      const prevLen = this.text()[cy - 1].length;
      this.text.update(text => {
        const t = text.map(r => [...r]);
        t[cy - 1] = [...t[cy - 1], ...t[cy]];
        t.splice(cy, 1);
        return t;
      });
      this.cy.update(y => y - 1);
      this.cx.set(prevLen);
    }
  }

  private deleteCharAt() {
    const cx = this.cx();
    const cy = this.cy();
    const row = this.text()[cy] ?? [];
    if (cx < row.length) {
      this.text.update(text => {
        const t = text.map(r => [...r]);
        t[cy].splice(cx, 1);
        return t;
      });
    } else if (cy < this.text().length - 1) {
      this.text.update(text => {
        const t = text.map(r => [...r]);
        t[cy] = [...t[cy], ...t[cy + 1]];
        t.splice(cy + 1, 1);
        return t;
      });
    }
  }

  private insertNewline() {
    const cx = this.cx();
    const cy = this.cy();
    this.text.update(text => {
      const t = text.map(r => [...r]);
      const current = t[cy] ?? [];
      t[cy] = current.slice(0, cx);
      t.splice(cy + 1, 0, current.slice(cx));
      return t;
    });
    this.cy.update(y => y + 1);
    this.cx.set(0);
  }
}
