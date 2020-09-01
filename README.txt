This is a MATLAB toolkit, containing 3 classes and 1 script.

The 3 classes make it possible to perform compressed sensing for a sparse sample of an 2-dimensional signal. The working mechanism of the toolkit relies on a toolkit named spgl1 and it also needs to be downloaded so that this toolkit works. SPGL1 download and instructions : https://friedlander.io/spgl1/.

The toolkit segemtns the signal the way user wants and does sparse recovery for each segment, individually.

Short descriptions of the classes of this toolkit :

    DataUnit : the basic unit containing a sparse sample, sampling locations and a sparse reconstruction of it.

    IMPORTANT METHODS :

    makeSparseReconstruction(dataunit) : makes the sparse reconstruction. Calling this method will start computer calculations

    getSparseReconstruction(dataunit) : returns the already calculated sparse reconstruction for the user

    SamplingSystem : The storage containing possibly many DataUnits

    GetMeASample : auxiliary, static methods.

IMPORTANT THINGS! :

1). dim_segment must be a factor of the size of the canonical input signal. If not, the program will run to an error.

2). methods commented as "aux method" are not needed by the user.