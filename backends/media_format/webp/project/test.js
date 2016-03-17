var Module = require('./webpdecoder.js');
var fs = require('fs');

var PNG = require('pngjs').PNG;

function toArrayBuffer(buffer) {
    var ab = new ArrayBuffer(buffer.length);
    var view = new Uint8Array(ab);
    for (var i = 0; i < buffer.length; ++i) {
        view[i] = buffer[i];
    }
    return ab;
}

fs.readFile('test.webp', function(err, data)
{
    if (err) throw err;
    var webpdata = new Uint8Array(toArrayBuffer(data));

    var buf = Module._malloc(webpdata.length * webpdata.BYTES_PER_ELEMENT);

    Module.HEAPU8.set(webpdata, buf);

    var resultCode = Module._initializeWebPDecoding(buf, webpdata.length);
    if (resultCode != 0)
    {
        process.stdout.write("error parsing webp");
        return;
    }

    var width = Module._getFeaturesWidth();
    var height = Module._getFeaturesHeight();

    var outputPointer = Module._decodeWebP(buf, webpdata.length);
    var bitmapView = new Uint8Array(Module.HEAPU8.buffer, outputPointer, width * height * 4);

    var bitmapViewToReturn = new Uint8Array(width * height * 4);
    bitmapViewToReturn.set(bitmapView);

    Module._free(buf);
    Module._free(outputPointer);

    var writepng = function() {

        var png = new PNG({
                filterType: -1,
                height: height,
                width: width
            });
        png.data = new Buffer(bitmapViewToReturn);

        png.pack().pipe(fs.createWriteStream('out.png'));
    };

    fs.exists('out.png',  function(exists) {
        if (exists)
        {
            fs.unlink('out.png', () => {
                writepng();
            });
        }
        else
        {
            writepng();
        }
    });
});