export const $ = (sel) => document.querySelector(sel);
export const $set = (dom, val) => (dom.value = val);
export const $get = (dom) => dom.value;
export const $inner = (dom, val) => (dom.innerText = val);
export const $on = (dom, ev, f) => dom.addEventListener(ev, f);
export const $click = (dom, f) => $on(dom, "click", f);
