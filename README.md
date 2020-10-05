# search_myers_IUPAC

## IUPAC code

| IUPAC   |      Base      |
|----------|:-------------:|
| A |  A  |
| C |  C  |
| G |  G  |
| T |  T  |
| R |  A or G |
| Y |  C or T |
| S |  G or C |
| W |  A or T |
| K |  G or T |
| M |  A or C |
| B |  C or G or T |
| D |  A or G or T |
| H |  A or C or T |
| V |  A or C or G |
| N |  A or C or G or T |


## Install

Install localy
```console
$ make install
```

## Usage

### Import package

```python
>>> import search_myers_IUPAC
```
### List of positions

Find all the **end positions** of the mapping of the **read** on the **text** with at most **k** errors

```python
>>> search_myers_IUPAC.listofpositions(text,read,k)
```

Example:

```python
>>> search_myers_IUPAC.listofpositions('HACTADGTRTG','HYC', 1)
[5, 6, 10]
```

The **read** 'HYC' appears in the **text** 'HACTADGTRTG' at the end positions 5, 6 and 10 with an error of at most 1.

### List of best positions

Find all the **end positions** of the mapping of the **read** on the **text** with the minimum number of errors **error**

```python
>>> search_myers_IUPAC.listofbestpositions(text,read)
```

Example:

```python
>>> search_myers_IUPAC.listofbestpositions('HACTADGTRTG','HYCAC')
(2, [2, 4, 5, 6])
```

The **read** 'HYCAC' appears in the **text** 'HACTADGTRTG' at the end positions 2, 4, 5 and 6 with an error of 2 and does not appear with an error of 0 or 1.

## List of first positions

Find the list of pairs (**start_position**,**error**) for all the position before the **end_position** for the mapping of the **read** on the **text** with at most **k** errors.

```python
>>> search_myers_IUPAC.backtrackpositions(text,read, k,end_position)
```

Example:

```python
>>> search_myers_IUPAC.backtrackpositions('HACTADGTRTG','HYCG', 1,10)
[(8, 1), (4, 1)]
```

The **read** 'HYCAC' appears in the **text** 'HACTADGTRTG' between the positions 8 and 10 and between the positions 4 and 10 with an error of 1.

## Find the maximal first position

Find the pair (**start_position**,**error**) for maximal position before the **end_position** for the mapping of the **read** on the **text** with at most **k** errors.

```python
>>> search_myers_IUPAC.backtrackbestposition(text,read, k,end_position)
```

Example:

```python
>>> search_myers_IUPAC.backtrackbestposition('HACTADGTRTG','HYCG', 1,10)
(8, 1)
```

The **read** 'HYCAC' appears in the **text** 'HACTADGTRTG' between the positions 8 and 10 with an error of 1.

## Find the Tag

Find the tag for maximal position before the **end_position** for the mapping of the **read** on the **text** with at most **k** errors.

- I : insertion
- D : deletion
- M : mutation
- = : same caracter

```python
>>> search_myers_IUPAC.tag(text,read, k,end_position)
```

Example

```python
>>> search_myers_IUPAC.backtrackbestposition('HACTADGTRTG','HYCG', 1,8)
(4, 1)
>>> 'HACTADGTRTG'[4:9]
'ADGTR'
>>> search_myers_IUPAC.tag('HACTADGTRTG','HYCG', 1,8)
'==MD='
```
