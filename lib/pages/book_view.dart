import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lexp/models/book.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookViewScreen extends StatefulWidget {
  const BookViewScreen({super.key, required this.book});

  final BookModel book;

  @override
  State<StatefulWidget> createState() {
    return _BookViewScreen();
  }
}

class _BookViewScreen extends State<BookViewScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  late PdfViewerController _pdfViewerController;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  void _showContextMenu(BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState overlayState = Overlay.of(context)!;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: details.selectedText));
            _pdfViewerController.clearSelection();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text('Copiar', style: TextStyle(fontSize: 17)),
        ),
      ),
    );
    overlayState.insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.bookname),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(widget.book.multimedia, key: _pdfViewerKey, onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
        if (details.selectedText == null && _overlayEntry != null) {
          _overlayEntry!.remove();
          _overlayEntry = null;
        } else if (details.selectedText != null && _overlayEntry == null) {
          _showContextMenu(context, details);
        }
      }),
    );
  }
}
