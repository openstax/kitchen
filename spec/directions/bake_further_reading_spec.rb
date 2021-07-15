# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeFurtherReading do

  before do
    stub_locales({
      'eoc': {
        'further-reading': 'Further Reading'
      }
    })
  end

  let(:further_reading) do
    chapter_element(
      <<~HTML
        <div data-type='page' id ="01">
          <h1 data-type="document-title" itemprop="name" id="first">First Title</h1>
          <section data-depth="1" id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm251544768" class="further-reading">
            <h3 data-type="title">Further Reading</h3>
            <p id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm229335040">Arendt, Hannah. 1971. “Thinking and Moral Considerations.” Social Research. 417-446.</p>
            <p id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm248689952">Masolo, Dismas, "African Sage Philosophy",
            <em data-effect="italics">The Stanford Encyclopedia of Philosophy</em>
            (Spring 2016 Edition), Edward N. Zalta (ed.), URL = https://plato.stanford.edu/archives/spr2016/entries/african-sage.</p>
            <p id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm229791248">
              Joshua Knobe, Department of Philosophy and Cognitive Science at Yale, Experimental Philosophy website: http://experimental-philosophy.yale.edu/ </p>
            <p id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm230734272">
              Ludlow, Peter, "Descriptions", <em data-effect="italics">The Stanford Encyclopedia of Philosophy</em> (Fall 2018 Edition), Edward N. Zalta (ed.), https://plato.stanford.edu/archives/fall2018/entries/descriptions.</p>
            <p id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm241179872">
              Joan Marques. “Consciousness at Work: A Review of Some Important Values, Discussed from a Buddhist Perspective,” <em data-effect="italics">Journal of Business Ethics</em>, Vol. 105, No. 1 (January 2012), 27-40.</p>
            <p id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm245874368">
              Daniels, Norman, "Reflective Equilibrium", <em data-effect="italics">The Stanford Encyclopedia of Philosophy</em> (Summer 2020 Edition), Edward N. Zalta (ed.), URL = https://plato.stanford.edu/archives/sum2020/entries/reflective-equilibrium.</p>
            <p id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm229358256">
              Plato. “The Theatetus,” translated by Benjamin Jowett. http://classics.mit.edu/Plato/theatu.html</p>
            </section>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.v1(chapter: further_reading, metadata_source: metadata_element)
    expect(further_reading).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div data-type='page' id ="01">
            <h1 data-type="document-title" itemprop="name" id="first">First Title</h1>
          </div>
          <div class="os-eoc os-further-reading-container" data-type="composite-page" data-uuid-key=".further-reading">
            <h2 data-type="document-title">
              <span class="os-text">Further Reading</span>
            </h2>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">Further Reading</h1>
              <div class="authors" id="authors_copy_1">Authors</div>
              <div class="publishers" id="publishers_copy_1">Publishers</div>
              <div class="print-style" id="print-style_copy_1">Print Style</div>
              <div class="permissions" id="permissions_copy_1">Permissions</div>
              <div data-type="subject" id="subject_copy_1">Subject</div>
            </div>
            <section data-depth="1" id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm251544768" class="further-reading">
            <p id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm229335040">Arendt, Hannah. 1971. “Thinking and Moral Considerations.” Social Research. 417-446.</p>
            <p id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm248689952">Masolo, Dismas, "African Sage Philosophy",
            <em data-effect="italics">The Stanford Encyclopedia of Philosophy</em>
            (Spring 2016 Edition), Edward N. Zalta (ed.), URL = https://plato.stanford.edu/archives/spr2016/entries/african-sage.</p>
            <p id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm229791248">
              Joshua Knobe, Department of Philosophy and Cognitive Science at Yale, Experimental Philosophy website: http://experimental-philosophy.yale.edu/ </p>
            <p id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm230734272">
              Ludlow, Peter, "Descriptions", <em data-effect="italics">The Stanford Encyclopedia of Philosophy</em> (Fall 2018 Edition), Edward N. Zalta (ed.), https://plato.stanford.edu/archives/fall2018/entries/descriptions.</p>
            <p id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm241179872">
              Joan Marques. “Consciousness at Work: A Review of Some Important Values, Discussed from a Buddhist Perspective,” <em data-effect="italics">Journal of Business Ethics</em>, Vol. 105, No. 1 (January 2012), 27-40.</p>
            <p id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm245874368">
              Daniels, Norman, "Reflective Equilibrium", <em data-effect="italics">The Stanford Encyclopedia of Philosophy</em> (Summer 2020 Edition), Edward N. Zalta (ed.), URL = https://plato.stanford.edu/archives/sum2020/entries/reflective-equilibrium.</p>
            <p id="auto_36fcc3ba-b6c3-4b33-bc0e-6760f13564b4_fs-idm229358256">
              Plato. “The Theatetus,” translated by Benjamin Jowett. http://classics.mit.edu/Plato/theatu.html</p>
            </section>
          </div>
        </div>
      HTML
    )
  end
end
