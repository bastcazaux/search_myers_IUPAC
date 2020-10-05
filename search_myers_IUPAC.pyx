# Copyright or © or Copr. Bastien Cazaux ([02/10/2020])
#
# email: bastien.cazaux@lirmm.fr
#
# This software is a computer program whose purpose is to search a small pattern in a text (both in IUPAC) with errors.
#
# This software is governed by the CeCILL-B license under French law and
# abiding by the rules of distribution of free software.  You can  use,
# modify and/ or redistribute the software under the terms of the CeCILL-B
# license as circulated by CEA, CNRS and INRIA at the following URL
# "http://www.cecill.info".
#
# As a counterpart to the access to the source code and  rights to copy,
# modify and redistribute granted by the license, users are provided only
# with a limited warranty  and the software's author,  the holder of the
# economic rights,  and the successive licensors  have only  limited
# liability.
#
# In this respect, the user's attention is drawn to the risks associated
# with loading,  using,  modifying and/or developing or reproducing the
# software by the user in light of its specific status of free software,
# that may mean  that it is complicated to manipulate,  and  that  also
# therefore means  that it is reserved for developers  and  experienced
# professionals having in-depth computer knowledge. Users are therefore
# encouraged to load and test the software's suitability as regards their
# requirements in conditions enabling the security of their systems and/or
# data to be ensured and,  more generally, to use and operate it in the
# same conditions as regards security.
#
# The fact that you are presently reading this means that you have had
# knowledge of the CeCILL-B license and that you accept its terms.

def listofpositions(str text,str read, long k):
    cdef long m, i, mm, Pv, Mv, g, Eq, Xh, Ph, Mh, Xv, j
    cdef list positions
    cdef dict tr
    cdef str x,c


    m = len(read)

    # Init
    tr = {
    'A': 0,
    'C': 0,
    'T': 0,
    'G': 0,
    }

    # Translate (IUPAC)
    for (i,x) in enumerate(read):
        if x in 'ARMWHVDN':
            tr['A'] += pow(2,i)
        if x in 'TYKWHBDN':
            tr['T'] += pow(2,i)
        if x in 'CYMSHBVN':
            tr['C'] += pow(2,i)
        if x in 'GRKSBVDN':
            tr['G'] += pow(2,i)

    # Update (IUPAC)
    tr['R'] = tr['A'] | tr['G']
    tr['Y'] = tr['T'] | tr['C']
    tr['M'] = tr['A'] | tr['C']
    tr['K'] = tr['G'] | tr['T']
    tr['S'] = tr['G'] | tr['C']
    tr['W'] = tr['A'] | tr['T']
    tr['H'] = tr['A'] | tr['T'] | tr['C']
    tr['B'] = tr['G'] | tr['T'] | tr['C']
    tr['V'] = tr['G'] | tr['A'] | tr['C']
    tr['D'] = tr['G'] | tr['A'] | tr['T']
    tr['N'] = tr['G'] | tr['A'] | tr['T'] | tr['C']



    mm = pow(2,m)

    Pv = pow(2,m) - 1
    Mv = 0
    g = m

    positions = []

    for (j,c) in enumerate(text):
        Eq = tr[c]
        Xh = ((((Eq & Pv) + Pv) % mm ) ^ Pv) | Eq
        Ph = Mv | (~ (Xh | Pv) % mm)
        Mh = Pv & Xh
        Xv = Eq | Mv
        Pv = ((Mh << 1) % mm) | (~ (Xv | ((Ph << 1) )) % mm)
        Mv = ((Ph << 1) % mm) & Xv
        g = g + (Ph >> m-1) - (Mh  >> m-1)
        if g <= k:
            positions.append(j)
    return positions

def listofbestpositions(str text,str read):
    cdef long m, i, mm, Pv, Mv, g, Eq, Xh, Ph, Mh, Xv, j
    cdef list positions
    cdef dict tr
    cdef str x,c


    m = len(read)

    # Init
    tr = {
    'A': 0,
    'C': 0,
    'T': 0,
    'G': 0,
    }

    # Translate (IUPAC)
    for (i,x) in enumerate(read):
        if x in 'ARMWHVDN':
            tr['A'] += pow(2,i)
        if x in 'TYKWHBDN':
            tr['T'] += pow(2,i)
        if x in 'CYMSHBVN':
            tr['C'] += pow(2,i)
        if x in 'GRKSBVDN':
            tr['G'] += pow(2,i)

    # Update (IUPAC)
    tr['R'] = tr['A'] | tr['G']
    tr['Y'] = tr['T'] | tr['C']
    tr['M'] = tr['A'] | tr['C']
    tr['K'] = tr['G'] | tr['T']
    tr['S'] = tr['G'] | tr['C']
    tr['W'] = tr['A'] | tr['T']
    tr['H'] = tr['A'] | tr['T'] | tr['C']
    tr['B'] = tr['G'] | tr['T'] | tr['C']
    tr['V'] = tr['G'] | tr['A'] | tr['C']
    tr['D'] = tr['G'] | tr['A'] | tr['T']
    tr['N'] = tr['G'] | tr['A'] | tr['T'] | tr['C']


    mm = pow(2,m)

    Pv = pow(2,m) - 1
    Mv = 0
    g = m

    error = m
    positions = []

    for (j,c) in enumerate(text):
        Eq = tr[c]
        Xh = ((((Eq & Pv) + Pv) % mm ) ^ Pv) | Eq
        Ph = Mv | (~ (Xh | Pv) % mm)
        Mh = Pv & Xh
        Xv = Eq | Mv
        Pv = ((Mh << 1) % mm) | (~ (Xv | ((Ph << 1) )) % mm)

        Mv = ((Ph << 1) % mm) & Xv
        g = g + (Ph >> m-1) - (Mh  >> m-1)
        if g < error:
            error = g
            positions = []
        if g == error:
            positions.append(j)
    return error,positions

def backtrackpositions(str text, str read, long k, long position):
    cdef long m, i, mm, Pv, Mv, g, Eq, Xh, Ph, Mh, Xv, j
    cdef list positions
    cdef dict tr
    cdef str x,c


    m = len(read)

    # Init
    tr = {
    'A': 0,
    'C': 0,
    'T': 0,
    'G': 0,
    }

    # Translate (IUPAC) of the reverse of read
    for (i,x) in enumerate(read[::-1]):
        if x in 'ARMWHVDN':
            tr['A'] += pow(2,i)
        if x in 'TYKWHBDN':
            tr['T'] += pow(2,i)
        if x in 'CYMSHBVN':
            tr['C'] += pow(2,i)
        if x in 'GRKSBVDN':
            tr['G'] += pow(2,i)

    # Update (IUPAC)
    tr['R'] = tr['A'] | tr['G']
    tr['Y'] = tr['T'] | tr['C']
    tr['M'] = tr['A'] | tr['C']
    tr['K'] = tr['G'] | tr['T']
    tr['S'] = tr['G'] | tr['C']
    tr['W'] = tr['A'] | tr['T']
    tr['H'] = tr['A'] | tr['T'] | tr['C']
    tr['B'] = tr['G'] | tr['T'] | tr['C']
    tr['V'] = tr['G'] | tr['A'] | tr['C']
    tr['D'] = tr['G'] | tr['A'] | tr['T']
    tr['N'] = tr['G'] | tr['A'] | tr['T'] | tr['C']


    mm = pow(2,m)

    Pv = pow(2,m) - 1
    Mv = 0
    g = m

    positions = []

    for i in range(min(position,2*len(read)+k)):

        j = position - i
        c = text[j]

        Eq = tr[c]
        if i == 0:
            Xh = ((((Eq & Pv) + Pv) % mm ) ^ Pv) | Eq
        else:
            Xh = (((((Eq & Pv) + Pv) % mm ) ^ Pv) | Eq ) & (pow(2,m) - 2)

        Ph = Mv | (~ (Xh | Pv) % mm)
        Mh = Pv & Xh
        Xv = Eq | Mv
        Pv = ((Mh << 1) % mm) | (~ (Xv | ((Ph << 1) )) % mm)

        Mv = ((Ph << 1) % mm) & Xv
        g = g + (Ph >> m-1) - (Mh  >> m-1)
        if g <= k:
            positions.append((j,g))

    return positions

def backtrackbestposition(str text, str read, long k, long position):
    bp = backtrackpositions(text,read,k,position)
    return min(bp,key=lambda x : x[1])


def tag(str text, str read, long k, long position_end):
    cdef long m, i, mm, Pv, Mv, g, Eq, Xh, Ph, Mh, Xv, j, position_start, error
    cdef list positions, matrix
    cdef dict tr
    cdef str x, c, tag



    position_start, error = backtrackbestposition(text, read, k, position_end)

    m = len(read)

    # Init
    tr = {
    'A': 0,
    'C': 0,
    'T': 0,
    'G': 0,
    }

    # Translate (IUPAC) of the reverse of read
    for (i,x) in enumerate(read):
        if x in 'ARMWHVDN':
            tr['A'] += pow(2,i)
        if x in 'TYKWHBDN':
            tr['T'] += pow(2,i)
        if x in 'CYMSHBVN':
            tr['C'] += pow(2,i)
        if x in 'GRKSBVDN':
            tr['G'] += pow(2,i)

    # Update (IUPAC)
    tr['R'] = tr['A'] | tr['G']
    tr['Y'] = tr['T'] | tr['C']
    tr['M'] = tr['A'] | tr['C']
    tr['K'] = tr['G'] | tr['T']
    tr['S'] = tr['G'] | tr['C']
    tr['W'] = tr['A'] | tr['T']
    tr['H'] = tr['A'] | tr['T'] | tr['C']
    tr['B'] = tr['G'] | tr['T'] | tr['C']
    tr['V'] = tr['G'] | tr['A'] | tr['C']
    tr['D'] = tr['G'] | tr['A'] | tr['T']
    tr['N'] = tr['G'] | tr['A'] | tr['T'] | tr['C']



    mm = pow(2,m)

    Pv = pow(2,m) - 1
    Mv = 0
    g = m

    positions = list(range(m,0,-1))
    matrix = [list(range(m,-1,-1))]

    for j in range(position_start,position_end+1):
        c = text[j]

        Eq = tr[c]
        if j == position_start:
            Xh = ((((Eq & Pv) + Pv) % mm ) ^ Pv) | Eq
        else:
            Xh = (((((Eq & Pv) + Pv) % mm ) ^ Pv) | Eq ) & (pow(2,m) - 2)

        Ph = Mv | (~ (Xh | Pv) % mm)
        Mh = Pv & Xh
        Xv = Eq | Mv
        Pv = ((Mh << 1) % mm) | (~ (Xv | ((Ph << 1) )) % mm)

        Mv = ((Ph << 1) % mm) & Xv
        g = g + (Ph >> m-1) - (Mh  >> m-1)

        l_Ph = [int(x) for x in bin(Ph)[2:].zfill(m)]
        l_Mh = [int(x) for x in bin(Mh)[2:].zfill(m)]
        positions = [positions[i]+l_Ph[i]-l_Mh[i] for i in range(m)]
        matrix.append(positions+[0])

    i = len(matrix)-1
    j = 0
    tag = ""

    while (i >= 0 and j < m):
        if i == 0:
            j += 1
            tag += "I"
            continue


        if matrix[i-1][j] == matrix[i][j] - 1:
            i -= 1
            tag += "D"
            continue
        if matrix[i][j+1] == matrix[i][j] - 1:
            j += 1
            tag += "I"
            continue
        if matrix[i-1][j+1] == matrix[i][j] - 1:
            i -= 1
            j += 1
            tag += "M"
            continue
        if matrix[i-1][j+1] == matrix[i][j] :
            i -= 1
            j += 1
            tag += "="
            continue

    return tag[::-1]

#
