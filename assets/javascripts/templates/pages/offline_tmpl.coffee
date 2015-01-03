app.templates.offlinePage = (docs) -> """
  <h1 class="_lined-heading">Offline Documentation</h1>
  <table class="_docs">
    <tr>
      <th>Documentation</th>
      <th class="_docs-size">Size</th>
      <th>Status</th>
      <th>Action</th>
    </tr>
    #{docs}
  </table>
  <h1 class="_lined-heading">Questions & Answers</h1>
  <dl>
    <dt>How does this work?
    <dd>Each page is cached as a key-value pair in <a href="https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API">IndexedDB</a> (downloaded from a single JSON file).<br>
        The app also uses <a href="https://developer.mozilla.org/en-US/docs/Web/HTML/Using_the_application_cache">AppCache</a> and <a href="https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API">localStorage</a> to cache the assets and index files.
    <dt>Can I close the tab/browser?
    <dd>#{canICloseTheTab()}
    <dt>What if I don't update a documentation?
    <dd>You'll see outdated content and some pages will be missing or broken, since the rest of the app (including data for the search and sidebar) uses a different caching mechanism and is updated automatically.<br>
        Documentation versioning is planned for the future but not yet supported, sorry.
    <dt>I found a bug, where do I report it?
    <dd>In the <a href="https://github.com/Thibaut/devdocs/issues">issue tracker</a>. Thanks!
    <dt>How do I uninstall/reset the app?
    <dd>Click <a href="javascript:app.reset()">here</a>.
    <dt>Why aren't all documentations listed above?
    <dd>You have to <a href="#" data-pick-docs>enable</a> them first.
  </dl>
"""

canICloseTheTab = ->
  if app.AppCache.isEnabled()
    """ Yes! Even offline, you can open a new tab, go to <a href="http://devdocs.io">devdocs.io</a>, and everything will work as if you were online (provided you downloaded all the documentations you want to use beforehand).<br>
        Note that loading any page other than <a href="http://devdocs.io">devdocs.io</a> directly won't work (due to limitations in AppCache). """
  else
    """ No. Because AppCache is unavailable in your browser (or has been disabled), loading <a href="http://devdocs.io">devdocs.io</a> offline won't work.<br>
        The current tab will continue to work, though (provided you downloaded all the documentations you want to use beforehand). """

app.templates.offlineDoc = (doc, status) ->
  outdated = status.downloaded and status.mtime isnt doc.mtime

  html = """
    <tr data-slug="#{doc.slug}"#{if outdated then ' class="_highlight"' else ''}>
      <td class="_docs-name _icon-#{doc.slug}">#{doc.name}</td>
      <td class="_docs-size">#{Math.ceil(doc.db_size / 100000) / 10} MB</td>
  """

  html += if !status.downloaded
    """
      <td>-</td>
      <td><a data-dl>Download</a></td>
    """
  else if outdated
    """
      <td>Outdated</td>
      <td><a data-dl>Update</a> - <a data-del>Delete</a></td>
    """
  else
    """
      <td>Up-to-date</td>
      <td><a data-del>Delete</a></td>
    """

  html + '</tr>'