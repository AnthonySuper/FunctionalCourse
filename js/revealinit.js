const initial = "https://cdn.jsdelivr.net/npm/reveal.js@3.9.2/";

async function reveal() {
	Reveal.initialize({
		controls: true,
		progress: true,
		history: true,
		center: true,

		transition: 'slide', // none/fade/slide/convex/concave/zoom

		// Optional reveal.js plugins, loaded from jsDelivr
		dependencies: [
			{ src: initial + 'lib/js/classList.js', condition: function() { return !document.body.classList; } },
			{ src: initial + 'plugin/markdown/marked.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
			{ src: initial + 'plugin/markdown/markdown.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
			{ src: initial + 'plugin/highlight/highlight.js', async: true, condition: function() { return !!document.querySelector( 'pre code' ); }, callback: function() { hljs.initHighlightingOnLoad(); } },
			{ src: initial + 'plugin/zoom-js/zoom.js', async: true },
			{ src: initial + 'plugin/notes/notes.js', async: true }
		]
	});
};

reveal();
