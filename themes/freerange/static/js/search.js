document.addEventListener('DOMContentLoaded', function() {
    let fuse;
    let posts = [];

    const searchInput = document.getElementById('search-input');
    const searchSummary = document.getElementById('search-summary');
    const searchList = document.getElementById('search-list');
    const noResults = document.getElementById('no-results');

    async function initSearch() {
        try {
            const response = await fetch('/index.json');
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            posts = await response.json();
            
            const fuseOptions = {
                keys: [
                    { name: 'title', weight: 0.4 },
                    { name: 'content', weight: 0.3 },
                    { name: 'tags', weight: 0.2 },
                    { name: 'categories', weight: 0.1 }
                ],
                threshold: 0.3,
                includeScore: true,
                includeMatches: true
            };

            fuse = new Fuse(posts, fuseOptions);
        } catch (error) {
            console.error('Failed to load search index:', error);
        }
    }

    function performSearch(query) {
        if (!fuse || !query.trim()) {
            clearResults();
            return;
        }

        const results = fuse.search(query);
        displayResults(results, query);
    }

    function displayResults(results, query) {
        if (results.length === 0) {
            searchSummary.textContent = '';
            searchList.innerHTML = '';
            noResults.style.display = 'block';
            return;
        }

        noResults.style.display = 'none';
        searchSummary.textContent = `Found ${results.length} result${results.length > 1 ? 's' : ''} for "${query}"`;
        
        searchList.innerHTML = results.map(result => {
            const post = result.item;
            const date = new Date(post.date).toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });

            return `
                <a href="${post.permalink}" class="btn btn--large btn--outline search-result-item">
                    <div class="search-result-title">${post.title}</div>
                    <div class="search-result-meta">${date.toUpperCase()} • ${post.readingTime} MIN READ</div>
                    ${post.description ? `<div class="search-result-summary">${post.description}</div>` : ''}
                    ${post.tags && post.tags.length > 0 ? 
                        `<div class="search-result-tags">
                            ${post.tags.slice(0, 3).map(tag => `<span class="search-result-tag">#${tag.toUpperCase()}</span>`).join(' ')}
                        </div>` : ''
                    }
                </a>
            `;
        }).join('');
    }

    function clearResults() {
        searchSummary.textContent = '';
        searchList.innerHTML = '';
        noResults.style.display = 'none';
    }

    if (searchInput) {
        searchInput.addEventListener('input', function(e) {
            performSearch(e.target.value);
        });

        initSearch();
    }
});
