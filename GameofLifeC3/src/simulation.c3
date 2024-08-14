module gameoflifec3;

struct Simulation
{
    bool run;
    int cells_live;

    Grid grid;
    Grid temp_grid;
}

def Table = int[<2>];

const ichar[<2>][8] NEIGHBORS_OFFSETS =
{
    {-1, 0 },
    { 1, 0 },
    { 0,-1 },
    { 0, 1 },
    {-1,-1 },
    {-1, 1 },
    { 1,-1 },
    { 1, 1 }
};


fn int Simulation.getValue(Simulation* self, Table grid) =>
    self.isWithinBounds(grid) ?
        self.grid.getValue(grid):0;

fn bool Simulation.isWithinBounds(Simulation* self, Table grid) @private =>
    grid.x >= 0 && grid.x < self.grid.rows && grid.y >= 0 && grid.y < self.grid.columns ? true : false;

fn int Simulation.countLiveNeighbors(Simulation* self, Table grid) {
    int live_neighbors = 0;

    foreach (offset: NEIGHBORS_OFFSETS) {
        int neighbors_row = (grid.x + offset.x + self.grid.getRows()) % self.grid.getRows();
        int neighbors_column = (grid.y + offset.y + self.grid.getColumns()) % self.grid.getColumns();

        live_neighbors += self.grid.getValue({neighbors_row, neighbors_column});
    }

    return live_neighbors;
}

fn void Simulation.draw(Simulation* self) => self.grid.draw();

fn void Simulation.clearGrid(Simulation* self) {
    if (self.isRunning()) { self.grid.clear(); }
}

fn void Simulation.toggleCell(Simulation* self, Table grid) {
    if (!self.isRunning() && self.isWithinBounds(grid)) {
        self.grid.toggleCell(grid);
    }
}

fn void Simulation.hoverCell(Simulation* self, Table grid) {
    if (self.isRunning() && !self.isWithinBounds(grid)) {
        return;
    }

    if (self.grid.getValue(grid) != 1) {
        self.grid.hoverCell(grid);
    }
}

fn int Simulation.getLivingCells(Simulation* self) => self.cells_live;

fn void Simulation.start(Simulation* self) => self.run = true;
fn void Simulation.stop(Simulation* self) => self.run = false;

fn bool Simulation.isRunning(Simulation* self) => self.run;
fn void Simulation.createRandomState(Simulation* self) {
    if (self.isRunning()) { self.grid.fillRandom(); }
}

fn void Simulation.update(Simulation* self) {
    if (!self.isRunning()) {
        return;
    }

    foreach (int idxr, row: self.grid.cells) {
        foreach (int idxc, _none: row)
        {
            Table pos = { idxr, idxc };

            int live_neighbors = self.countLiveNeighbors(pos);
            int cell_value = self.grid.getValue(pos);

            if (cell_value) {
                if (live_neighbors > 3 || live_neighbors < 2) {
                    self.temp_grid.setValue(pos, 0);
                    continue;
                }

                self.grid.setLivingCells();
                self.temp_grid.setValue(pos, 1);
                continue;
            }

            if (live_neighbors == 3) {
                self.grid.setLivingCells();
                self.temp_grid.setValue(pos, 1);
                continue;
            }

            self.temp_grid.setValue(pos, 0);
        }
    }

    self.cells_live = self.grid.l_cells;
    self.grid = self.temp_grid;
}
