import { Controller } from '@hotwired/stimulus';
import Rails from '@rails/ujs';
export default class extends Controller {
  static targets = ['input', 'results'];

  callSearch(inputTarget) {
    const { target } = inputTarget;
    const result = document.getElementById(`${target.dataset.elementId}`);

    Rails.ajax({
      url: `${target.dataset.urlValue}?search=${target.value}`,
      type: 'get',
      dataType: 'json',
      success: (res) => {
        result.innerHTML = res.html;
      },
    });
  }
}
