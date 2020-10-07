import search_myers_IUPAC

print("search_myers_IUPAC.listofpositions('HACTADGTRTG','HYC', 1)")
print(search_myers_IUPAC.listofpositions('HACTADGTRTG','HYC', 1))

print("search_myers_IUPAC.listofbestpositions('HACTADGTRTG','HYCAC')")
print(search_myers_IUPAC.listofbestpositions('HACTADGTRTG','HYCAC'))

print("search_myers_IUPAC.backtrackpositions('HACTADGTRTG','HYCG', 1,10)")
print(search_myers_IUPAC.backtrackpositions('HACTADGTRTG','HYCG', 1,10))

print("search_myers_IUPAC.backtrackbestposition('HACTADGTRTG','HYCG', 1,10)")
print(search_myers_IUPAC.backtrackbestposition('HACTADGTRTG','HYCG', 1,10))

print("search_myers_IUPAC.tag('HACTADGTRTG','HYCG', 1,8)")
print(search_myers_IUPAC.tag('HACTADGTRTG','HYCG', 1,8))

#
